class CreateBarbers < ActiveRecord::Migration[6.0]
  def change
  	create_table :barbers do |t|
  		t.text :name
  		t.text :type_prof
  		t.text :time_work
  	end
  	Barber.create :name=>'Наталія',:type_prof=>'Парикмахер',:time_work=>'08:00 - 17:00'
  	Barber.create :name=>'Олена',:type_prof=>'Парикмахер',:time_work=>'08:00 - 17:00'
  	Barber.create :name=>'Вікторія',:type_prof=>'Парикмахер',:time_work=>'10:00 - 19:00'
  	Barber.create :name=>'Анастасія',:type_prof=>'Парикмахер',:time_work=>'09:00 - 18:00'
  	Barber.create :name=>'Олена',:type_prof=>'Парикмахер',:time_work=>'10:00 - 17:00'
  end
end
