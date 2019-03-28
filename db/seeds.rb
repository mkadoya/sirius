# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

#csvファイルを扱うためのgemを読み込む
require 'csv'

#以下はQuestionsを呼び出すパターン
#  CSV.foreach('db/Questions.csv', headers: true) do |row|
#      Question.create(
#          :question_id => row[0],
#          :category => row[1],
#          :content => row[2],
#      )
#  end

#以下はItemsを呼び出すパターン
# CSV.foreach('db/Items.csv', headers: true) do |row|
# Item.create(
#     :item_id => row[0],
#     :maker => row[1],
#     :name => row[2],
#     :price => row[3],
#     :shop_num => row[4],
#     :rank => row[5],
#     :satisfaction => row[6],
#     :quote => row[7],
#     :revier => row[8],
#     :inch => row[9],
#     :resolution => row[10],
#     :wide => row[11],
#     :touchpannel => row[12],
#     :twoinone => row[13],
#     :cpu_name => row[14],
#     :cpu_clockspeed => row[15],
#     :cpu_core => row[16],
#     :cpu_score => row[17],
#     :hdd => row[18],
#     :hdd_speed => row[19],
#     :ssd => row[20],
#     :emmc => row[21],
#     :ram => row[22],
#     :ram_type => row[23],
#     :ram_empty_clot => row[24],
#     :gpu_name => row[25],
#     :gpu_ram => row[26],
#     :drive => row[27],
#     :dvd => row[28],
#     :blueray => row[29],
#     :wireless => row[30],
#     :lan => row[31],
#     :cellular => row[32],
#     :wifi_direct => row[33],
#     :nfc => row[34],
#     :faceprint => row[35],
#     :fingerprint => row[36],
#     :webcamera => row[37],
#     :bluetooth => row[38],
#     :tenkey => row[39],
#     :touchpen => row[40],
#     :gamingpc => row[41],
#     :fanless => row[42],
#     :hdmi => row[43],
#     :minihdmi => row[44],
#     :minidisplay => row[45],
#     :vga => row[46],
#     :usb_a => row[47],
#     :usb_c => row[48],
#     :sd => row[49],
#     :microsd => row[50],
#     :os => row[51],
#     :office => row[52],
#     :uptime => row[53],
#     :weight => row[54],
#     :color => row[55],
#     :date_sale => row[56],
#     :series => row[57],
#     :sirial => row[58],
#     :affiliate => row[59],
#     :image => row[60],
#     )
# end

# 以下はPatternsを呼び出すパターン
# CSV.foreach('db/Patterns.csv', headers: true) do |row|
# Pattern.create(
#     :category => row['category'],
#     :pattern_id => row['pattern_id'],
#     :answer_1 => row['answer_1'],
#     :answer_2 => row['answer_2'],
#     :answer_3 => row['answer_3'],
#     :answer_4 => row['answer_4'],
#     :answer_5 => row['answer_5'],
#     :answer_6 => row['answer_6'],
#     :answer_7 => row['answer_7'],
#     :answer_8 => row['answer_8'],
#     :answer_9 => row['answer_9'],
#     :answer_10 => row['answer_10'],
#     :answer_11 => row['answer_11'],
#     :answer_12 => row['answer_12']
#     )
# end

# 以下はPatternsを呼び出すパターン
# CSV.foreach('db/Characteristics.csv', headers: true) do |row|
# Characteristic.create(
#     :category => row[0],
#     :pattern_id => row[1],
#     :title => row[2],
#     :body => row[3],
#     :chara_1_str => row[4],
#     :chara_1_val => row[5],
#     :chara_2_str => row[6],
#     :chara_2_val => row[7],
#     :chara_3_str => row[8],
#     :chara_3_val => row[9],
#     :chara_4_str => row[10],
#     :chara_4_val => row[11],
#     :chara_5_str => row[12],
#     :chara_5_val => row[13],
#     :item_1 => row[14],
#     :item_2 => row[15],
#     :item_3 => row[16],
#     :item_4 => row[17],
#     :item_5 => row[18],
# )
# end

#以下はOptionを呼び出すパターン
   CSV.foreach('db/Options.csv', headers: true) do |row|
   Option.create(
       :option_id => row[0],
       :category => row[1],
       :question_id => row[2],
       :content => row[3],
       :next_question_id =>  row[4],
   )
 end

# 以下はMatchを呼び出すパターン
#  CSV.foreach('db/Matchs.csv', headers: true) do |row|
#  Match.create(
#      :match_id => row[0],
#      :category => row[1],
#      :option_id => row[2],
#      :item_clmn => row[3],
#      :min => row[4],
#      :max => row[5]
#  )
#  end

 #以下はOptionResultを呼び出すパターン
#  CSV.foreach('db/OptionResults.csv', headers: true) do |row|
#  OptionResult.create(
#      :user_id => row[0],
#      :category => row[1],
#      :question_id => row[2],
#      :option_id => row[3],
#      :result => row[4],
#  )
#  end
