class AddLink < ActiveRecord::Migration[5.2]
  def change
  	note_1 = Note.find(172)
  	reference_1 = note_1.references.find_or_create_by(title: "Decadence by Michel Onfray", author: "", file_type: "t", link: '<a target="_blank" href="https://www.amazon.ca/gp/product/2081380927/ref=as_li_tl?ie=UTF8&camp=15121&creative=330641&creativeASIN=2081380927&linkCode=as2&tag=picnotes20-20&linkId=69131677072978ab9c8d585123570f34">Decadence by Michel Onfray</a>')
	
	note_2 = Note.find(175)
  	reference_2 = note_2.references.find_or_create_by(title: "The Clash of Civilizations by Samuel Huntington", author: "", file_type: "t", link: '<a target="_blank" href="https://www.amazon.ca/gp/product/1451628978/ref=as_li_tl?ie=UTF8&camp=15121&creative=330641&creativeASIN=1451628978&linkCode=as2&tag=picnotes20-20&linkId=4f251c6d21b4db00b1a8b2e64d0b758d"> The Clash of Civilizations by Samuel Huntington</a>')

  	note_3 = Note.find(176)
  	reference_3 = note_3.references.find_or_create_by(title: "The Origins of Political Order by Francis Fukuyama", author: "", file_type: "t", link: '<a target="_blank" href="https://www.amazon.ca/gp/product/0374533229/ref=as_li_tl?ie=UTF8&camp=15121&creative=330641&creativeASIN=0374533229&linkCode=as2&tag=picnotes20-20&linkId=99b7a529565b747e63eacf8e098ad0fd">The Origins of Political Order by Francis Fukuyama</a>')

  	note_4 = Note.find(173)
  	reference_4 = note_4.references.find_or_create_by(title: "The Abyssinian by Jean-Christophe Rufin", author: "", file_type: "t", link: '<a target="_blank" href="https://www.amazon.ca/gp/product/B005QCBWZE/ref=as_li_tl?ie=UTF8&camp=15121&creative=330641&creativeASIN=B005QCBWZE&linkCode=as2&tag=picnotes20-20&linkId=1adf800d09ef2cd6d0b2b79f913522f8">The Abyssinian by Jean-Christophe Rufin"</a>')
  	
  	note_5 = Note.find(177)
  	reference_5 = note_5.references.find_or_create_by(title: "Principles of War by Carl von Clausewitz", author: "", file_type: "t", link: '<a target="_blank" href="https://www.amazon.ca/gp/product/0486427994/ref=as_li_tl?ie=UTF8&camp=15121&creative=330641&creativeASIN=0486427994&linkCode=as2&tag=picnotes20-20&linkId=9178510ba9c98c89e4663dbce1347cf3">Principles of War by Carl von Clausewitz</a>')
  end
end
