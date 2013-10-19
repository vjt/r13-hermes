namespace :hermes do
  desc 'Symlink public/assets/hermes-#{assets_digest}.js -> public/assets/hermes.js'
  task :symlink do
    digest = Rails.application.assets.digest.to_s
    from, to = "public/assets/hermes-#{digest}.js", 'public/assets/hermes.js'
    puts "#{from} -> #{to}"
    File.symlink from, to
  end
end
