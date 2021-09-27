class EnablePgcryptoExtension < ActiveRecord::Migration[6.1]
  def change
    def change
      enable_extension 'pgcrypto' unless extension_enabled?('pgcrypto')
    end
  end
end
