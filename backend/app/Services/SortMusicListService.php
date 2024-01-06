<?php

namespace App\Services;

use Illuminate\Support\Facades\Log;

class sortMusicListService
{
    // 巨大な数 初期値
    private const INF = 1000000007;
    // 最大検索曲数
    private const MAX_SEARCH_MUSIC_NUM = 30;
    // 誤差が少ない順にソートされた音楽リストを返す
    public function rhythmDiffSortService($data_rhythms, $user_rhythm)
    {
        // 誤差のデータが含まれる配列
        $rhythms_diff_list = [];
        foreach ($data_rhythms as $rhythm) {
            // 誤差を計算
            $rhythms_diff = $this->rhythmDiff(json_decode($rhythm['rhythm']), $user_rhythm);
            array_push($rhythms_diff_list, [
                'rhythm_diff' => $rhythms_diff,
                'title' => $rhythm['title'],
                'artist' => $rhythm['artist'],
            ]);
        }
        // 誤差が少ない順にソート
        $rhythms_diffs = array_column($rhythms_diff_list, 'rhythm_diff');
        array_multisort($rhythms_diffs, SORT_ASC, $rhythms_diff_list);
        
        Log::debug($rhythms_diff_list);

        // 最大検索曲数までに絞る
        $rhythms_diff_list = array_slice($rhythms_diff_list, 0, self::MAX_SEARCH_MUSIC_NUM);

        return $rhythms_diff_list;
    }

    private function rhythmDiff($data_rhythm, $user_rhythm)
    {
        // 合計時間が長い方のリズムをlong_rhythm, 短い方のリズムをshort_rhythmとする
        [$long_rhythm, $short_rhythm] = $this->longOrShort($data_rhythm, $user_rhythm);

        $long_rhythm_length = count($long_rhythm);
        $short_rhythm_length = count($short_rhythm);
        $rhythm_diff = self::INF;
        $start_index = 0;
        $can_calc = true;
        while ($can_calc) {
            $last_index = $this->getLastIndex($long_rhythm, $short_rhythm[$short_rhythm_length - 1], $start_index);
            if ($last_index == $long_rhythm_length - 1) {
                $can_calc = false;
            }
            // リズムの差分を計算
            $rhythm_diff = min($rhythm_diff, $this->listDiff($long_rhythm, $short_rhythm, $start_index, $last_index));
            $start_index++;
        }

        return $rhythm_diff;
    }

    private function listDiff($long_rhythm, $short_rhythm, $start_index, $last_index)
    {
        $start_time = 0;
        if ($start_index > 0) {
            $start_time = $long_rhythm[$start_index - 1];
        }
        $list_diff = 0;
        for ($i = 0; $i < count($short_rhythm); $i++) {
            $time_diff = self::INF;
            for ($j = $start_index; $j <= $last_index; $j++) {
                $time_diff = min($time_diff, abs($long_rhythm[$j] - $short_rhythm[$i] - $start_time));
            }
            $list_diff += $time_diff;
        }
        return $list_diff;
    }

    private function longOrShort($data_rhythm, $user_rhythm)
    {
        // 合計時間が長い方をlong_rhythm, 短い方をshort_rhythmとする
        $long_rhythm = [];
        $short_rhythm = [];
        if ($data_rhythm[count($data_rhythm) - 1] >= $user_rhythm[count($user_rhythm) - 1]) {
            $long_rhythm = $data_rhythm;
            $short_rhythm = $user_rhythm;
        } else {
            $long_rhythm = $user_rhythm;
            $short_rhythm = $data_rhythm;
        }
        return [$long_rhythm, $short_rhythm];
    }

    private function getLastIndex($long_rhythm, $short_last_time, $start_index)
    {
        $last_index = 0;
        $last_time_diff = self::INF;
        if ($start_index > 0) {
            $short_last_time += $long_rhythm[$start_index - 1];
        }
        for ($i = 0; $i < count($long_rhythm); $i++) {
            $time_diff = abs($long_rhythm[$i] - $short_last_time);
            if ($time_diff <= $last_time_diff) {
                $last_time_diff = $time_diff;
                $last_index = $i;
            } else {
                break;
            }
        }
        return $last_index;
    }
}