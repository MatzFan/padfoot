Sequel.migration do
  change do
    create_view :properties_owned, DB[:properties].select(
      [:uprn]).join(
        :trans_props, property_uprn: :uprn).join(
          :transactions, id: :transaction_id).join(
            :names_transactions, transaction_id: :id).join(
              :party_roles, name: :role).where(role_type: 'acquires')
  end
end
