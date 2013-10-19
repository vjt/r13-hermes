namespace :hermes do
  desc 'Symlink public/assets/hermes-#{assets_digest}.js -> public/assets/hermes.js'
  task :symlink do

    Dir["public/assets/hermes-*.js*"].each do |f|
      dst = File.basename(f)
      src = f.sub(/-[0-9a-f]+/, "")

      $stderr.puts "Symlink #{src} -> #{dst}"
      File.symlink(dst, src)
    end

  end
end
