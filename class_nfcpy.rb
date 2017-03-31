# #ここも自分のサーボにあったものに書き換える
# #s03t-2bbmg servo
# UNLOCK_ANGLE = "91"
# LOCK_ANGLE = "40"
#
# AUTO_LOCK = 40
require 'mysql2'


class User
 def initialize(name = nil, idm = nil, present = 0)
   @name = name
   @exit_idm = idm
   @current_present = present

   #一時的な情報保持のためのインスタンス変数
   @unlock_user = nil
   @current_idm = nil
 end
end

def idm(text)
 m = text.match(/ID=(.*?)\s/)
 get_idm = m[1]
 print("IDm = #{get_idm}\n")
 return get_idm
end

def nfc()
 #ここに自分の環境にあったものを指定
 `python2 ~/Desktop/practice_file/ruby_nfcpy/nfcpy/examples/tagtool.py`
end

def file_kanri_at(username, idm, status)
 if status == 0 #出社した時
   print("Good Morning #{username}!\n")
   puts("Let's do our best today!")

   time = Time.now
   File.open("#{username}.csv", "a") do |f|
     f.print("出社時刻")
     f.print(time.month, "月", time.day, "日", " ", time.hour, "：", time.min, "\n")
   end
   status_change = "update users set status = 1 where idm = '#{idm}';"
   results = $db.query(status_change)

 elsif status == 1 #帰社した時
   print("Good lack #{username}!\n")
   puts("Let's do our best tomorrow!")
   time = Time.now
   File.open("#{username}.csv", "a") do |f|
     f.print("退社時刻")
     f.print(time.month, "月", time.day, "日", " ", time.hour, "：", time.min, "\n")
   end
   status_change = "update users set status = 0 where idm = '#{idm}';"
   results = $db.query(status_change)
 end
end

#DBユーザー管理システム
$db = Mysql2::Client.new(:host => 'localhost', :user => 'root', :password => '')
usedb = $db.query(%q{use ruby_nfcpy;})

#mysqlからそれぞれのカラムを取得してくる
$select_name = $db.query(%q{select name from users;})
$select_idm = $db.query(%q{select idm from users;})
$select_status = $db.query(%q{select status from users;})

loop do
 unlock_user_id = idm(nfc)
 $select_column = $db.query(%q{select id, name, idm, status from users;})

 $select_column.each do |user|
   if user['idm'] == unlock_user_id
     file_kanri_at(user['name'], user['idm'], user['status']) #value is idm.
   end
 end

 print("Please wait reader restart...\n")
 sleep(2)

end
