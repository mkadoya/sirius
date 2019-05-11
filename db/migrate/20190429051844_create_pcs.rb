class CreatePcs < ActiveRecord::Migration[5.2]
  def change
    create_table :pcs do |t|
      t.integer :item_id
      t.string :category
      t.string :maker
      t.text :name
      t.integer :price
      t.integer :shop_num
      t.integer :rank
      t.decimal :satisfaction
      t.integer :quote
      t.integer :revier
      t.decimal :inch
      t.string :resolution
      t.boolean :wide
      t.boolean :touchpannel
      t.boolean :twoinone
      t.string :case
      t.string :cpu_name
      t.decimal :cpu_clockspeed
      t.integer :cpu_core
      t.integer :cpu_score
      t.integer :hdd
      t.integer :hdd_speed
      t.integer :ssd
      t.integer :emmc
      t.integer :optane
      t.integer :ram
      t.integer :volume
      t.integer :ram_max
      t.string :ram_type
      t.integer :ram_all_slot
      t.integer :ram_empty_clot
      t.string :gpu_name
      t.integer :gpu_ram
      t.integer :gpu_score
      t.boolean :drive
      t.boolean :dvd
      t.boolean :blueray
      t.boolean :wireless
      t.boolean :lan
      t.boolean :cellular
      t.boolean :wifi_direct
      t.boolean :nfc
      t.boolean :faceprint
      t.boolean :fingerprint
      t.boolean :webcamera
      t.boolean :bluetooth
      t.boolean :tenkey
      t.boolean :touchpen
      t.boolean :gamingpc
      t.boolean :fanless
      t.boolean :output_4k
      t.boolean :watercool
      t.boolean :tv_tuner
      t.boolean :tv_tuner_4k
      t.integer :hdmi
      t.integer :minihdmi
      t.integer :minidisplay
      t.integer :vga
      t.integer :usb_a
      t.integer :usb_c
      t.boolean :sd
      t.boolean :microsd
      t.string :os
      t.boolean :windows
      t.boolean :mac
      t.boolean :chrome
      t.string :office
      t.decimal :uptime
      t.decimal :weight
      t.string :color
      t.date :date_sale
      t.string :series
      t.string :sirial
      t.text :affiliate
      t.text :image

      t.timestamps
    end
  end
end
