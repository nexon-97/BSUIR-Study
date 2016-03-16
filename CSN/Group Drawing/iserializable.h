#ifndef ISERIALIZABLE_H
#define ISERIALIZABLE_H

#include <QByteArray>

template <typename T>
class ISerializable
{
public:
    virtual QByteArray serialize(T *object) = 0;
    virtual T* deserialize(QByteArray rawData) = 0;
};

template<typename T>
void putDataToByteArray(QByteArray &rawData, T *dataPtr)
{
    rawData.append((char*) dataPtr, sizeof(T));
}

template<typename T>
void getDataFromByteArray(char** dataPtr, T *unpackedData)
{
    memcpy(unpackedData, *dataPtr, sizeof(T));
    *dataPtr += sizeof(T);
}

#endif
