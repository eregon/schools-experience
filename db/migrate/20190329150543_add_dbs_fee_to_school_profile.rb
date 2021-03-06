class AddDbsFeeToSchoolProfile < ActiveRecord::Migration[5.2]
  def change
    add_column :schools_school_profiles, :dbs_fee_amount_pounds, :decimal, precision: 6, scale: 2
    add_column :schools_school_profiles, :dbs_fee_description, :text
    add_column :schools_school_profiles, :dbs_fee_interval, :string
    add_column :schools_school_profiles, :dbs_fee_payment_method, :text
  end
end
