class CcSession < Formula
  desc "Fast CLI tool for finding and resuming Claude Code sessions"
  homepage "https://github.com/cc-deck/cc-session"
  version "0.7.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/cc-deck/cc-session/releases/download/v0.7.3/cc-session-aarch64-apple-darwin.tar.xz"
      sha256 "2c44627f79c7e8b2962d0e94944e7d3749b78635e240d67eed1c789b4d11608f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/cc-deck/cc-session/releases/download/v0.7.3/cc-session-x86_64-apple-darwin.tar.xz"
      sha256 "c08240a9f9b13ce4f27643006554d7be0a00bf712c0efc5110eb94ad75dcef3a"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/cc-deck/cc-session/releases/download/v0.7.3/cc-session-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "c3709ec70814fc7f5be374c415365ba329e55b0afc4d6f34de73dd05bd0c364d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/cc-deck/cc-session/releases/download/v0.7.3/cc-session-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "04f88a7b3543e88c209a045a8434c277ebcf3ca640ab5b778227e584f19bbdc2"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-unknown-linux-gnu":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "cc-session" if OS.mac? && Hardware::CPU.arm?
    bin.install "cc-session" if OS.mac? && Hardware::CPU.intel?
    bin.install "cc-session" if OS.linux? && Hardware::CPU.arm?
    bin.install "cc-session" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
