
class ImodUid

  def initialize(uid, imap)
    @uid, @imap = uid, imap
  end

  def envelope
    @envelope ||= @imap.uid_fetch(@uid, 'ENVELOPE').first.attr['ENVELOPE']
  end

  def download
    @download ||= @imap.uid_fetch(@uid, 'RFC822').first.attr['RFC822']
  end

  def size_is_bigger_than?(some_size)
    data = @imap.uid_fetch(@uid, 'RFC822.SIZE')
    data.first.attr['RFC822.SIZE'] > some_size
  end

  def has_attachments?
    @imap.uid_fetch(@uid, 'BODYSTRUCTURE').first.attr['BODYSTRUCTURE'].multipart?
  end

  def raw
    @uid
  end

  # Delete mail identified by uid.
  def delete
    @imap.uid_store(raw, '+FLAGS', [:Deleted])
  end

end

