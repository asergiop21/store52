class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  #:registerable,
  devise :database_authenticatable, 
         :recoverable, :rememberable, :trackable, :validatable


  has_many :invoices
  has_many :accounting_records
  
  ROLE = %w[admin invitado ]

  validates_uniqueness_of :email, :case_sensitive => false


def self.current
      Thread.current[:user]
        end
  def self.current=(user)
        Thread.current[:user] = user
          end
  end


