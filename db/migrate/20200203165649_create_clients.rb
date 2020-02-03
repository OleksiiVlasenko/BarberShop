class CreateClients < ActiveRecord::Migration[6.0]
  def change
  	crete_table :client do |t|
  		t.text id
  		t.text name
  		t.text phone
  		t.text datestamp
  		t.text barber
  		t.text color
  		t.timestamps
  	end
  end
end
