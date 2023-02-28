class Users::PasswordGenerator

  def self.generate
    lower_letters = ('a'..'z').to_a
    upper_letters = ('A'..'Z').to_a
    simbols = ('#?!@$%^&*-').chars
    numbers = ('0'..'9').to_a
    password = ''
    cont = 0
    until cont == 4
      password += lower_letters[rand(lower_letters.size)] + upper_letters[rand(upper_letters.size)] + numbers[rand(numbers.size)] + simbols[rand(simbols.size)]
      cont += 1
    end
    password
  end

end
