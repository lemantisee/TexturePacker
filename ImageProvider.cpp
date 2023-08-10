#include "ImageProvider.h"

#include <QDebug>
#include <QFile>

#include "stb_image.h"
#include "stb_image_resize.h"

namespace {

}

ImageProvider::ImageProvider()
    : QQuickImageProvider(QQuickImageProvider::Image)
{}

QImage ImageProvider::requestImage(const QString &id, QSize *size, const QSize &requestedSize)
{
    QString filePath = id;

    if (!QFile::exists(filePath)) {
        qCritical("Unable to find image: %s", qUtf8Printable(filePath));
        return {};
    }

    int width = 0;
    int height = 0;
    int channels = 0;
    unsigned char *imageData = stbi_load(filePath.toStdString().c_str(), &width, &height, &channels, 0);
    if (!imageData || width == 0 || height == 0 || channels == 0) {
        qCritical("Unable to open image: %s", qUtf8Printable(filePath));
        return {};
    }

    if (channels != 3 && channels != 4) {
        qCritical("Image has %i channels. Supports only 3 and 4 channels: %s",
                  channels,
                  qUtf8Printable(filePath));
        return {};
    }

    if (width > 2048 || height > 2048) {
        QSize scaledSize = getDownscaleSize(width, height);
        qInfo("Image %s too big(%ix%i). Resizing to %ix%i",
              qUtf8Printable(filePath),
              width,
              height,
              scaledSize.width(),
              scaledSize.height());

        std::vector<uint8_t> scaledImage = scaleImage(imageData, width, height, channels, scaledSize);
        if (scaledImage.empty()) {
            qCritical("Unable to scale image: %s", qUtf8Printable(filePath));
            return {};
        }

        if (imageData) {
            stbi_image_free(imageData);
        }

        QImage image = createImage(scaledImage.data(), scaledSize, channels);
        if (image.isNull()) {
            qCritical("Unable to load image: %s", qUtf8Printable(filePath));
            return {};
        }

        if (size) {
            *size = image.size();
        }

        return image;
    }

    QImage image = createImage(imageData, {width, height}, channels);
    if (image.isNull()) {
        qCritical("Unable to load image: %s", qUtf8Printable(filePath));
        return {};
    }

    if (imageData) {
        stbi_image_free(imageData);
    }

    if (size) {
        *size = image.size();
    }

    return image;
}

QSize ImageProvider::getDownscaleSize(uint32_t width, uint32_t height) const
{
    return width > height ? QSize{2048, int(float(height) / float(width) * 2048.f)}
                          : QSize{int(float(width) / float(height) * 2048.f), 2048};
}

QImage ImageProvider::createImage(uint8_t *pixels, QSize size, int channels) const
{
    QImage::Format format = channels == 4 ? QImage::Format_RGBA8888 : QImage::Format_RGB888;

    QImage image(pixels, size.width(), size.height(), format);
    if (image.isNull()) {
        return {};
    }

    return image.copy();
}

std::vector<uint8_t> ImageProvider::scaleImage(
    uint8_t *pixels, uint32_t width, uint32_t height, int channels, QSize scaleSize) const
{
    std::vector<uint8_t> scaledImage;
    scaledImage.resize(scaleSize.width() * scaleSize.height() * channels);

    if (!stbir_resize_uint8(pixels,
                            width,
                            height,
                            0,
                            scaledImage.data(),
                            scaleSize.width(),
                            scaleSize.height(),
                            0,
                            channels)) {
        return {};
    }

    return scaledImage;
}
