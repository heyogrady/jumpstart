# More info at https://github.com/guard/guard#readme
guard 'livereload' do
  watch(%r{app/views/.+\.(erb)$})
  watch(%r{app/helpers/.+\.rb})
  watch(%r{public/.+\.(css|js|html)})
  watch(%r{config/locales/.+\.yml})
  watch(%r{(app|vendor)(/assets/\w+/(.+\.(css|js|html|png|jpg))).*}) { |m| "/assets/#{m[3]}" }
end
  
group :red_green_refactor, 
      halt_on_fail: true do
  guard :minitest,
        spring: true,
        all_on_start: false,
        all_after_pass: false,
        bundler: false do

    # send notificaitons to Growl
    notification :gntp

    # with Minitest::Unit
    watch(%r{^test/(.*)\/?test_(.*)\.rb$})
    watch(%r{^lib/(.*/)?([^/]+)\.rb$})     { |m| "test/#{m[1]}test_#{m[2]}.rb" }
    watch(%r{^test/test_helper\.rb$})      { 'test' }

    # with Minitest::Spec
    # watch(%r{^spec/(.*)_spec\.rb$})
    # watch(%r{^lib/(.+)\.rb$})         { |m| "spec/#{m[1]}_spec.rb" }
    # watch(%r{^spec/spec_helper\.rb$}) { 'spec' }

    # Rails 4
    watch(%r{^app/(.+)\.rb$})                               { |m| "test/#{m[1]}_test.rb" }
    watch(%r{^app/controllers/application_controller\.rb$}) { 'test/controllers' }
    watch(%r{^app/controllers/(.+)_controller\.rb$})        { |m| "test/integration/#{m[1]}_test.rb" }
    watch(%r{^app/services/(.+)_service\.rb})               { |m| "test/services/#{m[1]}_test.rb" }
    watch(%r{^app/workers/(.+)_worker\.rb})                 { |m| "test/workers/#{m[1]}_test.rb" }
    watch(%r{^app/views/(.+)_mailer/.+})                    { |m| "test/mailers/#{m[1]}_mailer_test.rb" }
    watch(%r{^lib/(.+)\.rb$})                               { |m| "test/lib/#{m[1]}_test.rb" }
    watch(%r{^app/views/(.+)/})                             { |m| "test/controllers/#{m[1]}_test.rb" }
    watch(%r{^test/.+_test\.rb$})
    watch(%r{^test/test_helper\.rb$}) { 'test' }

    # Rails < 4
    # watch(%r{^app/controllers/(.*)\.rb$}) { |m| "test/functional/#{m[1]}_test.rb" }
    # watch(%r{^app/helpers/(.*)\.rb$})     { |m| "test/helpers/#{m[1]}_test.rb" }
    # watch(%r{^app/models/(.*)\.rb$})      { |m| "test/unit/#{m[1]}_test.rb" }
    
  end

  guard :rubocop,
        cli: ['--format', 'clang', '--rails', '--display-cop-names'],
        all_on_start: false,
        keep_failed: false do
    watch(%r{.+\.rb$})
    watch(%r{(?:.+/)?\.rubocop\.yml$}) { |m| File.dirname(m[0]) }
  end

end
