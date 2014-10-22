class User
  class Repo
    def initialize
      @records = []
    end

    attr_reader :records

    def empty?
      records.empty?
    end

    def create(user)
      user.id = records.length
      records << user
    end

    def [](id)
      records[id]
    end

    def find_by_email(email)
      records.find { |r| r.email == email }
    end

    def authenticate(email, password)
      user = find_by_email(email)
      user && user.password == password ? user : nil
    end
  end
end