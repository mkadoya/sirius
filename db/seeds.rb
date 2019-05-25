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
# CSV.foreach('db/Questions.csv', headers: true) do |row|
#     Question.create(
#         :question_id => row[0],
#         :category => row[1],
#         :content => row[2],
#         :remain_question_num => row[3],
#     )
# end

# 以下はOptionを呼び出すパターン
# CSV.foreach('db/Options.csv', headers: true) do |row|
#     Option.create(
#        :option_id => row[0],
#        :category => row[1],
#        :question_id => row[2],
#        :content => row[3],
#        :next_question_id => row[4],
#    )
# end

# 以下はMatchを呼び出すパターン
# CSV.foreach('db/Matchs.csv', headers: true) do |row|
#   Match.create(
#      :match_id => row[0],
#      :category => row[1],
#      :option_id => row[2],
#      :item_clmn => row[3],
#      :min => row[4],
#      :max => row[5]
# )
# end

# 以下はColumnを呼び出すパターン
CSV.foreach('db/Columns.csv', headers: true) do |row|
  Column.create(
     :category => row[0],
     :column_name => row[1],
     :frendly_name => row[2],
     :unit => row[3],
     :available => row[4],
     :dsc_better => row[5],
     :fundamental => row[6],
     :remove => row[7],
     :item_info => row[8]
)
end

#以下はPcsを呼び出すパターン
# CSV.foreach('db/Pcs.csv', headers: true) do |row|
# Pc.create(
# 	:item_id => row[0],
# 	:category => row[1],
# 	:maker => row[2],
# 	:name => row[3],
# 	:price => row[4],
# 	:shop_num => row[5],
# 	:rank => row[6],
# 	:satisfaction => row[7],
# 	:quote => row[8],
# 	:revier => row[9],
# 	:inch => row[10],
# 	:resolution => row[11],
# 	:wide => row[12],
# 	:touchpannel => row[13],
# 	:twoinone => row[14],
# 	:case => row[15],
# 	:cpu_name => row[16],
# 	:cpu_clockspeed => row[17],
# 	:cpu_core => row[18],
# 	:cpu_score => row[19],
# 	:hdd => row[20],
# 	:hdd_speed => row[21],
# 	:ssd => row[22],
# 	:emmc => row[23],
# 	:optane => row[24],
# 	:ram => row[25],
# 	:volume => row[26],
# 	:ram_max => row[27],
# 	:ram_type => row[28],
# 	:ram_all_slot => row[29],
# 	:ram_empty_clot => row[30],
# 	:gpu_name => row[31],
# 	:ex_gpu =>  row[32],
# 	:gpu_ram => row[33],
# 	:gpu_score => row[34],
# 	:drive => row[35],
# 	:dvd => row[36],
# 	:blueray => row[37],
# 	:wireless => row[38],
# 	:lan => row[39],
# 	:cellular => row[40],
# 	:wifi_direct => row[41],
# 	:nfc => row[42],
# 	:faceprint => row[43],
# 	:fingerprint => row[44],
# 	:webcamera => row[45],
# 	:bluetooth => row[46],
# 	:tenkey => row[47],
# 	:touchpen => row[48],
# 	:gamingpc => row[49],
# 	:fanless => row[50],
# 	:output_4k => row[51],
# 	:watercool => row[52],
# 	:tv_tuner => row[53],
# 	:tv_tuner_4k => row[54],
# 	:hdmi => row[55],
# 	:minihdmi => row[56],
# 	:minidisplay => row[57],
# 	:vga => row[58],
# 	:usb_a => row[59],
# 	:usb_c => row[60],
# 	:sd => row[61],
# 	:microsd => row[62],
# 	:os => row[63],
# 	:windows => row[64],
# 	:mac => row[65],
# 	:chrome => row[66],
# 	:office => row[67],
# 	:microsoftoffice => row[68],
# 	:uptime => row[69],
# 	:weight => row[70],
# 	:color => row[71],
# 	:date_sale => row[72],
# 	:series => row[73],
# 	:sirial => row[74],
# 	:affiliate => row[75],
# 	:image => row[76],
# 	:cluster_1 => row[77],
# 	:cluster_2 => row[78],
# 		)
# end

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
# 		:volume => row[23],
#     :ram_type => row[24],
#     :ram_empty_clot => row[25],
#     :gpu_name => row[26],
#     :gpu_ram => row[27],
# 		:gpu_score => row[28],
#     :drive => row[29],
#     :dvd => row[30],
#     :blueray => row[31],
#     :wireless => row[32],
#     :lan => row[33],
#     :cellular => row[34],
#     :wifi_direct => row[35],
#     :nfc => row[36],
#     :faceprint => row[37],
#     :fingerprint => row[38],
#     :webcamera => row[39],
#     :bluetooth => row[40],
#     :tenkey => row[41],
#     :touchpen => row[42],
#     :gamingpc => row[43],
#     :fanless => row[44],
#     :hdmi => row[45],
#     :minihdmi => row[46],
#     :minidisplay => row[47],
#     :vga => row[48],
#     :usb_a => row[49],
#     :usb_c => row[50],
#     :sd => row[51],
#     :microsd => row[52],
#     :os => row[53],
#     :windows => row[54],
#     :mac => row[55],
#     :chrome => row[56],
#     :office => row[57],
#     :uptime => row[58],
#     :weight => row[59],
#     :color => row[60],
#     :date_sale => row[61],
#     :series => row[62],
#     :sirial => row[63],
#     :affiliate => row[64],
#     :image => row[65],
#     )
# end

#以下はToiletPaperを呼び出すパターン
# CSV.foreach('db/Toiletpaper_items.csv', headers: true) do |row|
# ToiletpaperItem.create(
#     :item_id => row[0],
#     :category => row[1],
#     :maker => row[2],
#     :name => row[3],
#     :price => row[4],
#     :single => row[5],
#     :double => row[6],
#     :cost => row[7],
#     :soft => row[8],
#     :flavor => row[9],
#     :smooth => row[10],
#     :water => row[11],
#     :design => row[12],
#     :fun => row[13],
#     :series => row[14],
#     :affiliate => row[15],
#     :image => row[16],
# )
# end

#以下はPcsを呼び出すパターン
# CSV.foreach('db/Pcs.csv', headers: true) do |row|
# Pc.create(
#     :item_id => row[0],
#     :category => row[1],
#     :maker => row[2],
#     :name => row[3],
#     :price => row[4],
#     :shop_num => row[5],
#     :rank => row[6],
#     :satisfaction => row[7],
#     :quote => row[8],
#     :revier => row[9],
#     :inch => row[10],
#     :resolution => row[11],
#     :wide => row[12],
#     :touchpannel => row[13],
#     :twoinone => row[14],
#     :case => row[15],
#     :cpu_name => row[16],
#     :cpu_clockspeed => row[17],
#     :cpu_core => row[18],
#     :cpu_score => row[19],
#     :hdd => row[20],
#     :hdd_speed => row[21],
#     :ssd => row[22],
#     :emmc => row[23],
#     :optane => row[24],
#     :ram => row[25],
#     :volume => row[26],
#     :ram_max => row[27],
#     :ram_type => row[28],
#     :ram_all_slot => row[29],
#     :ram_empty_clot => row[30],
#     :gpu_name => row[31],
#     :ex_gpu =>  row[32],
#     :gpu_ram => row[33],
#     :gpu_score => row[34],
#     :drive => row[35],
#     :dvd => row[36],
#     :blueray => row[37],
#     :wireless => row[38],
#     :lan => row[39],
#     :cellular => row[40],
#     :wifi_direct => row[41],
#     :nfc => row[42],
#     :faceprint => row[43],
#     :fingerprint => row[44],
#     :webcamera => row[45],
#     :bluetooth => row[46],
#     :tenkey => row[47],
#     :touchpen => row[48],
#     :gamingpc => row[49],
#     :fanless => row[50],
#     :output_4k => row[51],
#     :watercool => row[52],
#     :tv_tuner => row[53],
#     :tv_tuner_4k => row[54],
#     :hdmi => row[55],
#     :minihdmi => row[56],
#     :minidisplay => row[57],
#     :vga => row[58],
#     :usb_a => row[59],
#     :usb_c => row[60],
#     :sd => row[61],
#     :microsd => row[62],
#     :os => row[63],
#     :windows => row[64],
#     :mac => row[65],
#     :chrome => row[66],
#     :office => row[67],
#     :microsoftoffice => row[68],
#     :uptime => row[69],
#     :weight => row[70],
#     :color => row[71],
#     :date_sale => row[72],
#     :series => row[73],
#     :sirial => row[74],
#     :affiliate => row[75],
#     :image => row[76],
#     :cluster_1 => row[77],
#     :cluster_2 => row[78],
#       )
# end

# 以下はCategoryを呼び出すパターン
# CSV.foreach('db/Category.csv', headers: true) do |row|
#   Category.create(
#      :category_id => row[0],
#      :category => row[1],
#      :name => row[2],
# )
# end

#以下はActive Admin用
# AdminUser.create!(email: 'mkadoya111@gmail.com', password: 'pa55w0rd!', password_confirmation: 'pa55w0rd!') if Rails.env.development?
