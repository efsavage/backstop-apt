class Backstop < Formula
  desc "High-performance API Gateway and Cache"
  homepage "https://github.com/efsavage/backstop"
  url "https://github.com/efsavage/backstop/releases/download/v0.1.0/backstop"
  version "0.1.0"
  sha256 ""

  def install
    bin.install "backstop"
  end

  service do
    run [opt_bin/"backstop"]
    keep_alive true
    log_path var/"log/backstop.log"
    error_log_path var/"log/backstop.log"
  end

  test do
    system "#{bin}/backstop", "--version"
  end
end
