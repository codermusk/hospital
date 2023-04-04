class DoorKeeper < ActiveRecord::Migration[6.0]

    def change
      create_table :oauth_applications do |t|
        t.string  :name,    null: false
        t.string  :uid,     null: false
        t.string  :secret,  null: false

        # Remove `null: false` if you are planning to use grant flows
        # that doesn't require redirect URI to be used during authorization
        # like Client Credentials flow or Resource Owner Password.
        t.text    :redirect_uri, null: false
        t.string  :scopes,       null: false, default: ''
        t.boolean :confidential, null: false, default: true
        t.timestamps             null: false
      end
      #
      add_index :oauth_applications, :uid, unique: true

      create_table :oauth_access_grants do |t|
        t.references :resource_owner,  null: false
        t.references :application,     null: false
        t.string   :token,             null: false
        t.integer  :expires_in,        null: false
        t.text     :redirect_uri,      null: false
        t.string   :scopes,            null: false, default: ''
        t.datetime :created_at,        null: false
        t.datetime :revoked_at
      end

      add_index :oauth_access_grants, :token, unique: true
      add_foreign_key(
        :oauth_access_grants,
        :oauth_applications,
        column: :application_id
      )


      add_foreign_key(
        :oauth_access_tokens,
        :oauth_applications,
        column: :application_id
      )

      # Uncomment below to ensure a valid reference to the resource owner's table
      add_foreign_key :oauth_access_grants,:accounts, column: :resource_owner_id
    end
  end

