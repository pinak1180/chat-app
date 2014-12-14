class AppDoc < ActiveRecord::Base
    def get_content(which)
      which.to_i == 1 ? AppDoc.first.privacy : AppDoc.first.tos
    end
end