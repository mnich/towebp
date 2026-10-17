# Homebrew formula template for towebp.
# Copy this file to Formula/towebp.rb in the mnich/homebrew-tools tap
# and update `url` and `sha256` for every new release.
class Towebp < Formula
  desc "Multi-threaded CLI for batch conversion of JPG/PNG images to WebP"
  homepage "https://github.com/mnich/towebp"
  url "https://github.com/mnich/towebp/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "REPLACE_WITH_SHA256_OF_RELEASE_TARBALL"
  license "MIT"

  # Official webp package, provides cwebp
  depends_on "webp"

  def install
    bin.install "towebp"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/towebp --version")
    system bin/"towebp", "--help"
  end
end
