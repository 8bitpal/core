module Messaging
  class IntercomProxy
    def self.instance
      @instance ||= Messaging::IntercomProxy.new
    end

    def update_user(id, attrs, env = nil)
      return if skip? env

      user = find_user(id)
      return if user.blank?

      attrs.each do |key, value|
        user.send("#{key.to_s}=", value)
      end
      user.save
    end

    def create_user(attrs, env = nil)
      return if skip? env

      ::Intercom::User.create(attrs)

    rescue ::Intercom::AuthenticationError,
            ::Intercom::ServerError,
            ::Intercom::BadGatewayError,
            ::Intercom::ServiceUnavailableError,
            ::Intercom::ResourceNotFound => e
      raise Bucky::NonFatalException.new(e)
    end

    def add_tag(user_id, tag, env = nil)
      return if skip? env

      add_user_to_tag(user_id, tag)
    end

    def remove_tag(user_id, tag, env = nil)
      return if skip? env

      remove_user_from_tag(user_id, tag)
    end

    def update_tags(attrs, env = nil)
      return if skip? env

      attrs[:tag_list].each do |name|
        add_user_to_tag(attrs[:id], name)
      end
    end

    def track(id, action_name, occurred_at = Time.current, env = nil)
      return if skip? env

      user = ::Intercom::User.find(user_id: id)
      user.custom_attributes["#{action_name}_at"] = occurred_at
      user.save

    rescue ::Intercom::AuthenticationError,
            ::Intercom::ServerError,
            ::Intercom::BadGatewayError,
            ::Intercom::ServiceUnavailableError,
            ::Intercom::ResourceNotFound => e
      raise Bucky::NonFatalException.new(e)
    end

    def skip?(env, expected_env = 'production')
      env != expected_env
    end

  private

    def find_user(id)
      ::Intercom::User.find(user_id: id)
    rescue Intercom::ResourceNotFound
      return nil
    rescue ::Intercom::AuthenticationError,
            ::Intercom::ServerError,
            ::Intercom::BadGatewayError,
            ::Intercom::ServiceUnavailableError => e
      raise Bucky::NonFatalException.new(e)
    end

    def add_user_to_tag(id, name)
      tag = find_or_create_tag(name)
      ::Intercom::Tag.tag_users(tag, [id.to_s])
    end


    def remove_user_from_tag(id, name)
      tag = find_or_create_tag(name)
      ::Intercom::Tag.untag_users(tag, [id.to_s])
    end

    def find_or_create_tag(name)
      tag = find_tag_by_name(name)
      tag.present? ? tag : new_tag(name)
    end

    def find_tag_by_name(name)
      ::Intercom::Tag.find(name: name)
    rescue Intercom::ResourceNotFound
      return nil
    rescue ::Intercom::AuthenticationError,
            ::Intercom::ServerError,
            ::Intercom::BadGatewayError,
            ::Intercom::ServiceUnavailableError => e
      raise Bucky::NonFatalException.new(e)
    end

    def new_tag(name=nil)
      tag = ::Intercom::Tag.new
      tag.name = name unless name.nil?
      tag
    rescue ::Intercom::AuthenticationError,
            ::Intercom::ServerError,
            ::Intercom::BadGatewayError,
            ::Intercom::ServiceUnavailableError,
            ::Intercom::ResourceNotFound => e
      raise Bucky::NonFatalException.new(e)
    end
  end
end
