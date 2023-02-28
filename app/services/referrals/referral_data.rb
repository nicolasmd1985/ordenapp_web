class Referrals::ReferralData

  def initialize(referral, order)
    @args_referral = referral
    @order = order
  end

  def process
    referral = Referral.create(comment: EnsureUtf8Encode.new(@args_referral[:comment]).process,
                               signature: @args_referral[:signature].delete("\n"),
                               full_name: EnsureUtf8Encode.new(@args_referral[:full_name]).process,
                               final_time: @args_referral[:final_time],
                               email: EnsureUtf8Encode.new(@args_referral[:email]).process,
                               order_id: @order)
    if referral.save
      return referral, true
    else
      return referral, false
    end
  end

end
