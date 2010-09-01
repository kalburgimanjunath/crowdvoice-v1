
#
# This is a convenience monkey patch
#
class Net::IMAP

 def uid_move(uid, mailbox)
   uid_copy(uid, mailbox)
   uid_store(uid, '+FLAGS', [:Deleted])
 end

end
