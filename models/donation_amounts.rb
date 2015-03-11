module DonationAmounts

  def suggested_donation_amounts
    [5, 10, 15, 20, 25, 40, 50, 75, 100, 200, 250, 350, 500, 1000]
  end

  def valid_donation_amount?(amount)
    (amount.is_a?(Numeric) and amount > 0)
  end

  def add_donation_amounts(amounts)
    if amounts.respond_to? :each
      amounts.each do |amount|
        self.add_donation_amount(amount)
      end
    else
      self.add_donation_amount(amounts)
    end
  end

  def donation_amounts_list
    if self.donation_amounts.nil?
      []
    else
      self.donation_amounts.split '|'
    end
  end

  def donation_amount?(amount)
    self.donation_amounts_list.include? amount.to_s
  end

  def reset_donation_amounts
    self.donation_amounts = nil
  end

  protected
  def add_donation_amount(amount)
    if self.valid_donation_amount? amount
      if not self.donation_amounts_list.include? amount.to_s
        if self.donation_amounts_list.empty?
          self.donation_amounts = "#{amount}"
        else
          self.donation_amounts = "#{self.donation_amounts}|#{amount}"
        end
      end
    else
      raise StandardError "#{amount} is not an acceptable value."
    end
  end
end