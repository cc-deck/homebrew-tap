class CcSession < Formula
  desc "Fast CLI tool for finding and resuming Claude Code sessions"
  homepage "https://github.com/cc-deck/cc-session"
  version "0.7.9"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/cc-deck/cc-session/releases/download/v0.7.9/cc-session-aarch64-apple-darwin.tar.xz"
      sha256 "89108a99d98c3346d6ea0d92189b73d7c7ea50dc59f2c6a440577891be217240"
    end
    if Hardware::CPU.intel?
      url "https://github.com/cc-deck/cc-session/releases/download/v0.7.9/cc-session-x86_64-apple-darwin.tar.xz"
      sha256 "7927ca73f02061930503fac41f6f541780905a95b900d98e68c53f7983ab2d56"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/cc-deck/cc-session/releases/download/v0.7.9/cc-session-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "610b55256d2e172188622d8da1586161bac2819108d1ec621a6cc0302b6fbd5e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/cc-deck/cc-session/releases/download/v0.7.9/cc-session-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "508392c94a48e3b083b6bf1fc9587f255609459582bb816a414b9ec42ebdb56f"
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
