class CreateBarbers < ActiveRecord::Migration[6.0]
  def change
  	create_table :barbers do |t|
  		t.text :name
  		t.text :type_prof
  		t.text :time_work
  	end
  	Barber.create :name=>'Alex',:type_prof=>'Парикмахер',:time_work=>'08:00 - 17:00'
  end
end
