
require 'md5'

#  PLUGIN
#
# - Detect if email size is downloadable.
# - Move mail to a specific folder if its too big.
# - Move mail to a revised folder if it has no attachments.
# - Validate that the email belongs to a user.
# - If attachments are found and user is correct download attachments.
# - Move mail with attachments to revised folder.
#
class ImodAttachmentDownloaderPlugin < ImodPlugin

  def post_initialize
    safely_create_mailbox(@config.downloaded_mails_folder)
    safely_create_mailbox(@config.oversized_mails_folder)
  end

  def parse_mail(uid)
    @uid = ImodUid.new(uid, @imap)
    return nil unless valid_user?
    return send_too_big_notification if mail_is_too_big?
    process_attachments_for(TMail::Mail.parse @uid.download)
    move_mail_to(@config.downloaded_mails_folder)
  end

  def cleanup
  end

  protected

  def send_too_big_notification
    log_too_big_notification
    SubscriptionMailer.imap_download_too_big(
      subject,
      target_sender_mail_address,
      target_mail_address
    ).deliver
    nil
  end

  def log_too_big_notification
    @log.info 'Sending too big notification'
    @log.info "Subject: [#{subject}]"
    @log.info "Email  : [#{target_sender_mail_address}]"
  end

  # TODO: validate if user can send mails to this address
  #
  # Envelope Fields:
  #
  # - date: Returns a string that represents the date.
  # - subject:  Returns a string that represents the subject.
  # - from: Returns an array of Net::IMAP::Address that represents the from.
  # - sender: Returns an array of Net::IMAP::Address that represents the sender.
  # - reply_to: Returns an array of Net::IMAP::Address that represents the reply-to.
  # - to: Returns an array of Net::IMAP::Address that represents the to.
  # - cc: Returns an array of Net::IMAP::Address that represents the cc.
  # - bcc:  Returns an array of Net::IMAP::Address that represents the bcc.
  # - in_reply_to:  Returns a string that represents the in-reply-to.
  # - message_id: Returns a string that represents the message-id.
  #
  #  <code>
  #    p envelope.to #=>
  #    [#<struct Net::IMAP::Address name="Tagged", route=nil,
  #      mailbox="tagged", host="taggedmail.com">]
  #  <code>
  #
  # TODO: Check every single recipient in the array?
  #   (In case there is many (to:) recipients??)
  #
  # TODO: Move mails with invalid addressed to a different folder?
  #
  def valid_user?
    Voice.valid_mailbox?(target_recipient)
  end

  def target_recipient
    @uid.envelope.to.first.mailbox
  end

  def target_mail_address
    [@uid.envelope.to.first.mailbox, @uid.envelope.to.first.host].join('@')
  end

  def target_sender_mail_address
    [@uid.envelope.from.first.mailbox, @uid.envelope.from.first.host].join('@')
  end

  def subject
    @uid.envelope.subject
  end

  def mail_is_too_big?
    return false unless @uid.size_is_bigger_than?(@config.max_mail_size)
    @log.info 'Mail is too big, skipping'
    move_mail_to(@config.oversized_mails_folder)
    true
  end

  def process_attachments_for(mail)
    @log.info "Processing [#{mail.subject}]"
    return if mail.attachments.blank?
    @log.info "Detected #{mail.attachments.count} attachment(s)"
    mail.attachments.each { |attachment| process_attachment(attachment, mail) }
  end

  # TODO: Refactor this method, is getting too big!
  def process_attachment(attachment, mail)
    filename = target_filepath attachment
    @log.info 'Downloading attachment'

    # store to local disk
    File.open(filename, 'w+') { |local_file| local_file << attachment.gets(nil) }

    # create voice
    voice = Voice.find_by_target_recipient(target_recipient)

    # pass over the temp file to the image object to make paperclip
    # extract width, and height
    temp = File.new(filename, 'r')
    im = voice.images.build(
      :url => "http://no-url-set.com/#{filename}",
      :mailed_attachment => temp,
      :emailed_from => target_mail_address,
      :description => mail.subject
    )

    # Don't crash, ensure that imap connection closes and log error
    unless voice.save
      @log.debug(im.errors.inspect)
    end

    # close socket, and delete temporal file.
    temp.close
    File.delete(filename)
  end

  def target_filepath(attachment)
    basename = File.basename(attachment.original_filename)
    extension = File.extname(basename)
    File.join(
      @config.save_to_folder,
      MD5.hexdigest(basename + Time.now.tv_sec.to_s) + extension
    )
  end

  def move_mail_to(target)
    @log.info "Moving '#{@uid.raw}' to folder '#{target}'"
    @imap.uid_move(@uid.raw, target)
  end

  def safely_create_mailbox(name)
    begin
      @imap.create(name)
    rescue Net::IMAP::NoResponseError => e
    end
  end

  # Convinience method, leave here for when we need to delete mailboxes!
  def remove_mailbox(name)
    safely_create_mailbox(name)
    @imap.delete(name)
    safely_create_mailbox(name)
  end

end

