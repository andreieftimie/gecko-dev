/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef INDEX_H_
#define INDEX_H_

#include "media/stagefright/MediaSource.h"
#include "mozilla/Monitor.h"
#include "mp4_demuxer/mp4_demuxer.h"

namespace mp4_demuxer
{

template <typename T> class Interval;
class MoofParser;

class Index
{
public:
  Index(const stagefright::Vector<stagefright::MediaSource::Indice>& aIndex,
        Stream* aSource, uint32_t aTrackId);
  ~Index();

  void ConvertByteRangesToTimeRanges(
    const nsTArray<mozilla::MediaByteRange>& aByteRanges,
    nsTArray<Interval<Microseconds>>* aTimeRanges);

private:
  mozilla::Monitor mMonitor;
  nsTArray<stagefright::MediaSource::Indice> mIndex;
  nsAutoPtr<MoofParser> mMoofParser;
};
}

#endif
