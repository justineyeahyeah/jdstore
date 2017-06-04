# == Schema Information
#
# Table name: products
#
#  id               :integer          not null, primary key
#  title            :string
#  description      :text
#  price            :integer
#  quantity         :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  image            :string
#  position         :integer
#  author           :string
#  publisher        :string
#  pages            :integer
#  is_shelved       :boolean          default(FALSE)
#  publication_date :date
#

class Product < ApplicationRecord
  mount_uploader :image, ImageUploader
  acts_as_list
  belongs_to :category
  has_many :comments
  has_many :product_favs
  has_many :users, through: :product_favs, source: :user

  def shelve!
    self.is_shelved = true
    self.save
  end

  def off_shelve!
    self.is_shelved = false
    self.save
  end





end
