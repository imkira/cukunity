Cucumber::Rake::Task.new(:android) do |features|
  features.cucumber_opts = "features --format progress -t ~@ios,@android"
end
namespace :android do
  Cucumber::Rake::Task.new(:pretty) do |features|
    features.cucumber_opts = "features --format pretty -t ~@ios,@android"
  end
  Cucumber::Rake::Task.new(:wip) do |features|
    features.cucumber_opts = "features --format pretty -t ~@ios,@android -t @wip --wip"
  end
end
Cucumber::Rake::Task.new(:ios) do |features|
  features.cucumber_opts = "features --format progress -t ~@android,@ios"
end
namespace :ios do
  Cucumber::Rake::Task.new(:pretty) do |features|
    features.cucumber_opts = "features --format pretty -t ~@android,@ios"
  end
  Cucumber::Rake::Task.new(:wip) do |features|
    features.cucumber_opts = "features --format pretty -t ~@android,@ios -t @wip --wip"
  end
end
