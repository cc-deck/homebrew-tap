class CcSession < Formula
  desc "Fast CLI tool for finding and resuming Claude Code sessions"
  homepage "https://github.com/cc-deck/cc-session"
  version "0.9.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/cc-deck/cc-session/releases/download/v0.9.1/cc-session-aarch64-apple-darwin.tar.xz"
      sha256 "1ea4152c173fd29fa24e90f3a5c65248319e539ec2f99fe54975218347b6b7d9"
    end
    if Hardware::CPU.intel?
      url "https://github.com/cc-deck/cc-session/releases/download/v0.9.1/cc-session-x86_64-apple-darwin.tar.xz"
      sha256 "2be533f9fbaff8d54fd7b160a661cba6d999b46380baa5763d26ced1a2c6ae91"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/cc-deck/cc-session/releases/download/v0.9.1/cc-session-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "c45dc4eec79510b58ad1be98573b38b394ff745702ebd532c4765a5f56d68a4b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/cc-deck/cc-session/releases/download/v0.9.1/cc-session-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "a22c45a58006a3fab95c752f9d62fd29ba014887bda1fdc8b0adf98384d2eb74"
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
