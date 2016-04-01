Sequel.migration do
  change do
    create_view :property_owners, DB[:properties].join(
      :trans_props, property_uprn: :uprn).join(
        :transactions, id: :transaction_id).join(
          :names_transactions, transaction_id: :id).join(
            :party_roles, name: :role).where(role_type: 'acquires').select(
              :uprn, :name_id, :date).select_append(
                :transactions__type___trans_type) # alias
  end
end
