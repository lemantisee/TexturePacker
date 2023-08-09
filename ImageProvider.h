#pragma once

#include <QQuickImageProvider>

class ImageProvider : public QQuickImageProvider
{
public:
    ImageProvider();

    QImage requestImage(const QString &id, QSize *size, const QSize& requestedSize) override;

private:
    QSize getDownscaleSize(uint32_t width, uint32_t height) const;
    QImage createImage(uint8_t *pixels, QSize size, int channels) const;
    std::vector<uint8_t> scaleImage(
        uint8_t *pixels, uint32_t width, uint32_t height, int channels, QSize scaleSize) const;
};

