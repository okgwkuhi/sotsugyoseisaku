class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :posts, dependent: :destroy
  has_many :applications, dependent: :destroy

  STYLES = ["じっくり系", "ワイワイ系"].freeze
  LEVELS = ["初心者", "中級者", "上級者"].freeze

  validates :name, presence: true, length: { maximum: 255 }
  validates :style, inclusion: { in: STYLES }
  validates :level, inclusion: { in: LEVELS }
end
