class Event < ApplicationRecord
  belongs_to :user
  has_many :contact_requests, dependent: :destroy
  has_many :users, through: :contact_requests
  GENRE_ARRAY = ["Disco", "Blues", "Funk", "Jazz", "Metal", "Pop", "Punk", "Rap", "Rock", "Country", "Reggae", "Gospel", "Soul", "Kompa", "Classic"]
  TYPE_EVENT_ARRAY = ['Play together', 'Learn together']
  EVENT_INSTRUMENTS_ARRAY = ["Guitare", "Drums", "Piano", "Bass", "Maracass", "Keyboard", "Bass guitar", "Violin", "Viola", "Cello", "Flute", "Trumpet", "Saxophone", "Singing"]
  EVENT_INSTRUMENTS_ARRAY1 = ["Guitare", "Drums", "Piano", "Bass", "Maracass", "Keyboard", "Singing"]
  EVENT_INSTRUMENTS_ARRAY2 = ["Violin", "Viola", "Cello", "Flute", "Trumpet", "Saxophone", "Bass guitar"]

  after_create :reject_empty_element

  def reject_empty_element
    reject = self.instruments_array.reject(&:empty?)
    self.update(instruments_array: reject)
  end

  def participants
    self.contact_requests.where(status: 'Accepted').map(&:user)
  end

  def places_left
    self.instruments_array.count - self.users.count
  end

  def available_instruments
    self.instruments_array - self.contact_requests.where(status: 'Accepted').map { |request| request.instrument.name }
  end

end
