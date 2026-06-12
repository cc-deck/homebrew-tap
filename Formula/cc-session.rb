class CcSession < Formula
  desc "Fast CLI tool for finding and resuming Claude Code sessions"
  homepage "https://github.com/cc-deck/cc-session"
  version "0.7.8"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/cc-deck/cc-session/releases/download/v0.7.8/cc-session-aarch64-apple-darwin.tar.xz"
      sha256 "f8013fd1e1e4aa33b339ae8829abaca9b8d27fe7d20d1e5f9e4d65797b048bef"
    end
    if Hardware::CPU.intel?
      url "https://github.com/cc-deck/cc-session/releases/download/v0.7.8/cc-session-x86_64-apple-darwin.tar.xz"
      sha256 "cd6848587d619115d3d2ad9f6ed1a7c4bb007f9b04021164870a0f52a36ec1ba"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/cc-deck/cc-session/releases/download/v0.7.8/cc-session-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "1a9e7ea518bc286b91cf40bb965171c42890107896249f0361740fc0a794268b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/cc-deck/cc-session/releases/download/v0.7.8/cc-session-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "0ea4997ef53e23c69f500d185b96cbd52c99e71137b8b32ea204be7f3d9ad614"
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
