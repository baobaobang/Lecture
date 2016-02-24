//
//  Transcoder.m
//  Upload
//
//  Created by mortal on 16/1/18.
//  Copyright © 2016年 禾医健康科技. All rights reserved.
//

#import "Transcoder.h"
#import <lame/lame.h>
@implementation Transcoder


/**
 *  转MP3
 *
 *  @param filePath    原文件路径
 *  @param mp3savePath 目标文件路径
 */
+ (void)transcodeToMP3From:(NSString *)filePath toPath:(NSString *)mp3savePath
{
    @try {
        int read, write;
        
        FILE *pcm = fopen([filePath cStringUsingEncoding:1], "rb");  //source 被转换的音频文件位置
        fseek(pcm, 4*1024, SEEK_CUR);                                   //skip file header
        FILE *mp3 = fopen([mp3savePath cStringUsingEncoding:1], "wb");  //output 输出生成的Mp3文件位置
        
        const int PCM_SIZE = 8192;
        const int MP3_SIZE = 8192;
        short int pcm_buffer[PCM_SIZE*2];
        unsigned char mp3_buffer[MP3_SIZE];
        
        lame_t lame = lame_init();
        //lame_set_in_samplerate(lame, 11025.0);
        lame_set_in_samplerate(lame, 44100.0);
        lame_set_VBR(lame, vbr_default);
        lame_init_params(lame);
        
        do {
            read = fread(pcm_buffer, 2*sizeof(short int), PCM_SIZE, pcm);
            if (read == 0)
                write = lame_encode_flush(lame, mp3_buffer, MP3_SIZE);
            else
                write = lame_encode_buffer_interleaved(lame, pcm_buffer, read, mp3_buffer, MP3_SIZE);
            
            fwrite(mp3_buffer, write, 1, mp3);
            
        } while (read != 0);
        
        lame_close(lame);
        fclose(mp3);
        fclose(pcm);
    }
    @catch (NSException *exception) {
        NSLog(@"%@",[exception description]);
    }  
    @finally {  
//        self.audioFileSavePath = mp3FilePath;  
        NSLog(@"MP3生成成功: %@",mp3savePath);
        NSFileManager *fileManager = [NSFileManager defaultManager];
        [fileManager removeItemAtPath:filePath error:nil];
        
    }
    
}

+ (void)concatFiles:(NSArray<NSString *> *)files to :(NSString *)toPath{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager createFileAtPath:toPath contents:nil attributes:nil];
    NSFileHandle *inFile = [NSFileHandle fileHandleForWritingAtPath:toPath];
    for (NSString *filePath in files) {
        NSFileHandle *outFile = [NSFileHandle fileHandleForReadingAtPath:filePath];
        
        NSDictionary *dic = [fileManager attributesOfItemAtPath:filePath error:nil];
        long long size = [dic[NSFileSize] longLongValue];
        long long point = 0;
        NSData *tempData;
        int times = (int)size/100000;
        for (int i = 1; i<=times; i++) {
            if (i == times) {
                tempData = [outFile readDataOfLength:[dic[NSFileSize] longLongValue]-(times-1)*100000];
            }else{
                tempData = [outFile readDataOfLength:100000];
                point+=100000;
                [outFile seekToFileOffset:point];
            }
            [inFile writeData:tempData];
            
            //移除分段的文件
            [fileManager removeItemAtPath:filePath error:nil];
        }
    }
}
@end
