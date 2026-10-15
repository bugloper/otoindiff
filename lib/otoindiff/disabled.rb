# frozen_string_literal: true

module Otoindiff
  # Refinement that restores plain Hash key access where it is activated.
  #
  # otoindiff is enabled globally on require. Activate this refinement in a
  # class (or file) that needs strict String/Symbol key distinction; Hash calls
  # written lexically inside it bypass the indifferent lookup.
  #
  # @example Opt a single class out
  #   class StrictParser
  #     using Otoindiff::Disabled
  #
  #     def call(hash)
  #       hash['foo']  # only matches the String key 'foo'
  #     end
  #   end
  module Disabled
    refine Hash do
      def [](key)
        original_brackets(key)
      end

      def fetch(key, *args, &block)
        original_fetch(key, *args, &block)
      end

      # Native #dig (on Hash, Array, Struct) dispatches to the globally patched
      # Hash#dig of nested hashes, so walk the path one key at a time to keep
      # every level strict.
      def dig(key, *rest)
        [key, *rest].reduce(self) do |current, k|
          break nil if current.nil?

          current.is_a?(Hash) ? current.original_brackets(k) : current.dig(k)
        end
      end
    end
  end
end
