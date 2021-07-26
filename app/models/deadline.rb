class Deadline < ActiveRecord::Base

  belongs_to :article
  belongs_to :stock

end
