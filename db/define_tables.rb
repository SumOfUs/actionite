def campaigners_table(db)
  begin
    # Some DBs return false, others raise an exception, this handles both cases.
    if not db.table_exists? :campaigners
      create_campaigners_table db
    end
  rescue
    create_campaigners_table db
  end
end

def petitions_table(db)
  begin
    # Some DBs return false, others raise an exception, this handles both cases.
    if not db.table_exists? :petitions
      create_petitions_table db
    end
  rescue
    create_petitions_table db
  end
end

def create_campaigners_table(db)
  # Create the table
  db.create_table :campaigners do
    primary_key :id
    String :google_id
    String :email
    String :image
  end
end

def create_petitions_table(db)
  # Create the table
  db.create_table :petitions do
    primary_key :id
    # Unique identifiers
    String :name, null: false
    String :slug, null: false
    unique :name
    unique :slug

    # Required values
    Text :body, null: false
    Text :mobile_body, null: false
    String :title, null: false
    String :facebook_title, null: false
    String :language, default: '/rest/v1/language/100/'
    String :blockquote, null: false

    # The other details
    Text :alt_body
    String :image_url
    String :image_text
    String :required_fields
    String :suggested_tweets
    Integer :goal
    TrueClass :auto_increment_goal, :default => false

    # Housekeeping
    DateTime :created_at
    DateTime :updated_at

    # Allow us to disable Petitions - index because it'll be part of all queries.
    TrueClass :disabled
    index :disabled
  end
end