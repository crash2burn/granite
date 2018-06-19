class Granite::Base
  def self.drop_and_create
  end
end

require "uuid"

{% for adapter in GraniteExample::ADAPTERS %}
  {% adapter_literal = adapter.id %}
  require "../src/adapter/{{ adapter_literal }}"

  module {{adapter.capitalize.id}}
    class Parent < Granite::Base
      primary id : Int64
      adapter {{ adapter_literal }}
      table_name parents

      field name : String
      timestamps

      has_many :students

      validate :name, "Name cannot be blank" do |parent|
        !parent.name.to_s.blank?
      end
    end

    class Teacher < Granite::Base
      primary id : Int64
      adapter {{ adapter_literal }}
      table_name teachers

      field name : String

      has_many :klasss
    end

    class Student < Granite::Base
      primary id : Int64
      adapter {{ adapter_literal }}
      table_name students

      field name : String

      has_many :enrollments
      has_many :klasss, through: :enrollments
    end

    class Klass < Granite::Base
      primary id : Int64
      adapter {{ adapter_literal }}
      table_name klasss
      field name : String

      belongs_to :teacher

      has_many :enrollments
      has_many :students, through: :enrollments
    end

    class Enrollment < Granite::Base
      primary id : Int64
      adapter {{ adapter_literal }}
      table_name enrollments

      belongs_to :student
      belongs_to :klass
    end

    class School < Granite::Base
      adapter {{ adapter_literal }}
      primary custom_id : Int64
      field name : String

      table_name schools
    end

    class Nation::County < Granite::Base
      adapter {{ adapter_literal }}
      primary id : Int64
      table_name nation_countys

      field name : String
    end

    class Review < Granite::Base
      adapter {{ adapter_literal }}
      table_name reviews
      field name : String
      field downvotes : Int32
      field upvotes : Int64
      field sentiment : Float32
      field interest : Float64
      field published : Bool
      field created_at : Time
    end

    class HasBytes < Granite::Base
      adapter {{ adapter_literal }}
      table_name has_bytes
      field bytes : Bytes
      field name : String
    end

    class Empty < Granite::Base
      adapter {{ adapter_literal }}
      table_name emptys
      primary id : Int64
    end

    class ReservedWord < Granite::Base
      adapter {{ adapter_literal }}
      table_name "select"
      field all : String
    end

    class Callback < Granite::Base
      adapter {{ adapter_literal }}
      table_name callbacks
      primary id : Int64
      field name : String

      property history : IO::Memory = IO::Memory.new

      {% for name in Granite::Callbacks::CALLBACK_NAMES %}
        {{name.id}} _{{name.id}}
        private def _{{name.id}}
          history << "{{name.id}}\n"
        end
      {% end %}
    end

    class CallbackWithAbort < Granite::Base
      adapter {{ adapter_literal }}
      table_name callbacks_with_abort
      primary abort_at : String, auto: false
      field do_abort : Bool

      property history : IO::Memory = IO::Memory.new

      {% for name in Granite::Callbacks::CALLBACK_NAMES %}
        {{name.id}} do
          abort! if do_abort && abort_at == "{{name.id}}"
          history << "{{name.id}}\n"
        end
      {% end %}
    end

    class Kvs < Granite::Base
      adapter {{ adapter_literal }}
      table_name kvss
      primary k : String, auto: false
      field v : String
    end

    class Person < Granite::Base
      adapter {{ adapter_literal }}
      table_name people

      field name : String
    end

    class Company < Granite::Base
      adapter {{ adapter_literal }}
      table_name companies

      primary id : Int32
      field name : String
    end

    class Book < Granite::Base
      adapter {{ adapter_literal }}
      table_name books
      has_many :book_reviews
      belongs_to author : Person
      belongs_to publisher : Company, foreign_key: publisher_id : Int32

      primary id : Int32
      field name : String
    end

    class BookReview < Granite::Base
      adapter {{ adapter_literal }}
      table_name book_reviews
      belongs_to :book, foreign_key: book_id : Int32

      primary id : Int32
      field body : String
    end

    class Item < Granite::Base
      adapter {{ adapter_literal }}
      table_name items

      primary item_id : String, auto: false
      field item_name : String

      before_create :generate_uuid

      def generate_uuid
        @item_id = UUID.random.to_s
      end
    end

    class NonAutoDefaultPK < Granite::Base
      adapter {{ adapter_literal }}
      table_name non_auto_default_pk

      primary id : Int64, auto: false
      field name : String
    end

    class NonAutoCustomPK < Granite::Base
      adapter {{ adapter_literal }}
      table_name non_auto_custom_pk

      primary custom_id : Int64, auto: false
      field name : String
    end

    class Article < Granite::Base
      adapter {{ adapter.id }}
      table_name articles

      primary id : Int64
      field articlebody : String
    end

    class Comment < Granite::Base
      adapter {{ adapter.id }}
      table_name comments

      primary id : Int64
      field commentbody : String
      field articleid : Int64
    end

    class ArticleViewModel < Granite::Base
      adapter {{ adapter.id }}

      field articlebody : String
      field commentbody : String

      query <<-SQL
        SELECT articles.id, articles.articlebody, comments.commentbody FROM articles JOIN comments ON comments.articleid = articles.id
      SQL
    end

    Parent.migrator.drop_and_create
    Teacher.migrator.drop_and_create
    Student.migrator.drop_and_create
    Klass.migrator.drop_and_create
    Enrollment.migrator.drop_and_create
    School.migrator.drop_and_create
    Nation::County.migrator.drop_and_create
    Review.migrator.drop_and_create
    Empty.migrator.drop_and_create
    ReservedWord.migrator.drop_and_create
    Callback.migrator.drop_and_create
    CallbackWithAbort.migrator.drop_and_create
    Kvs.migrator.drop_and_create
    Person.migrator.drop_and_create
    Company.migrator.drop_and_create
    Book.migrator.drop_and_create
    BookReview.migrator.drop_and_create
    Item.migrator.drop_and_create
    NonAutoDefaultPK.migrator.drop_and_create
    NonAutoCustomPK.migrator.drop_and_create
    Article.migrator.drop_and_create
    Comment.migrator.drop_and_create

  end
{% end %}
