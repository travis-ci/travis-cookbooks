# frozen_string_literal: true

module MixConfigHelper
  def self.render_hash(opts)
    "[#{opts.map { |k, v| "#{k}: #{render_value(v)}" }.join(', ')}]"
  end

  def self.render_array(values)
    "[#{values.map { |v| render_value(v) }.join(', ')}]"
  end

  def self.render_value(v)
    # XXX we can't really render char lists.
    case v
    when Hash then render_hash(v)
    when Array then render_array(v)
    else v.inspect
    end
  end

  def self.render_config(config)
    config.map do |key, opts|
      "config :#{key}, #{render_value(opts)}"
    end.join("\n")
  end
end
