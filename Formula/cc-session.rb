class CcSession < Formula
  desc "Fast CLI tool for finding and resuming Claude Code sessions"
  homepage "https://github.com/cc-deck/cc-session"
  version "0.7.4"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/cc-deck/cc-session/releases/download/v0.7.4/cc-session-aarch64-apple-darwin.tar.xz"
      sha256 "a6a59dcc40f3cf907b7ba97fc16d6251e7be6d4916e8db6fb6e15b52cdaa8825"
    end
    if Hardware::CPU.intel?
      url "https://github.com/cc-deck/cc-session/releases/download/v0.7.4/cc-session-x86_64-apple-darwin.tar.xz"
      sha256 "df346b2d2a62c3ab93c86a784d0dd9febb533313b9fa84978223129585ea048e"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/cc-deck/cc-session/releases/download/v0.7.4/cc-session-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "dcfe64168c06c5d01bbf1086ccd3873ad5bc58fd863f68604cb6a57fc195c394"
    end
    if Hardware::CPU.intel?
      url "https://github.com/cc-deck/cc-session/releases/download/v0.7.4/cc-session-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "5323ef442bfa2f61bbc00596d10e427037a253f79a2fbf833def0da133729da9"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin": {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin": {},
    "x86_64-unknown-linux-gnu": {}
  }

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
    if OS.mac? && Hardware::CPU.arm?
      bin.install "cc-session"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "cc-session"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "cc-session"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "cc-session"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
