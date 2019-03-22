class CreateItems < ActiveRecord::Migration[5.2]
  def change
    create_table :items do |t|

      t.integer :item_id
      t.string :maker
      t.text :name
      t.integer :price
      t.integer :shop_num
      t.integer :rank
      t.numeric :satisfaction
      t.integer :quote
      t.integer :revier
      t.numeric :inch
      t.text :resolution
      t.boolean :wide
      t.boolean :touchpannel
      t.boolean :twoinone
      t.text :cpu_name
      t.numeric :cpu_clockspeed
      t.integer :cpu_core
      t.integer :cpu_score
      t.integer :hdd
      t.integer :hdd_speed
      t.integer :ssd
      t.integer :emmc
      t.integer :ram
      t.text :ram_type
      t.integer :ram_empty_clot
      t.text :gpu_name
      t.integer :gpu_ram
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
      t.integer :hdmi
      t.integer :minihdmi
      t.integer :minidisplay
      t.integer :vga
      t.integer :usb_a
      t.integer :usb_c
      t.boolean :sd
      t.boolean :microsd
      t.text :os
      t.text :office
      t.numeric :uptime
      t.numeric :weight
      t.text :color
      t.date :date_sale
      t.text :series
      t.text :sirial
      t.text :affiliate
      t.text :image

    end
  end
end
