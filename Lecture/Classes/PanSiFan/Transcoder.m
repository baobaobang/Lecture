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

//+ (void)transcodeToMP3From:(NSString *)filePath toPath:(NSString *)mp3savePath{
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//    NSError *error;
//    NSDictionary *dic = [fileManager attributesOfItemAtPath:filePath error:&error];
//    
//    long long size = [dic[NSFileSize] longLongValue];
//    [fileManager createFileAtPath:mp3savePath contents:nil attributes:nil];
//    NSFileHandle *outFile = [NSFileHandle fileHandleForReadingAtPath:filePath];
//    NSFileHandle *inFile = [NSFileHandle fileHandleForWritingAtPath:mp3savePath];
//    
//    
//    
//    lame_t lame;
//    // mp3压缩参数
//    lame = lame_init();
//    lame_set_num_channels(lame, 1);
//    lame_set_in_samplerate(lame, 44100);
//    lame_set_brate(lame, 16);
//    lame_set_mode(lame, 1);
//    lame_set_quality(lame, 2);
//    lame_init_params(lame);
//    
//    NSMutableData *mp3Datas = [[NSMutableData alloc] init];
//    
//    UInt64 point = 0;
//    int64_t times = size/5000;
//    NSData *tempData;
//    for (int64_t i = 1; i<=times;i++) {
//        if (i == times) {
//            tempData = [outFile readDataOfLength:size - (times-1)*5000];
//        }else{
//            tempData = [outFile readDataOfLength:5000];
//            point += 5000;
//            [outFile seekToFileOffset:point];
//        }
//        short *recordingData = (short *)tempData.bytes;
//        int pcmLen = (int)tempData.length;
//        int nsamples = pcmLen / 2;
//        
//        unsigned char buffer[pcmLen];
//        // mp3 encode
//        int recvLen = lame_encode_buffer(lame, recordingData, recordingData, nsamples, buffer, pcmLen);
//        // add NSMutable
//        [mp3Datas appendBytes:buffer length:recvLen];
//        //[inFile writeData:[Transcoder transcodeData:tempData]];
//    }
//    [inFile writeData:mp3Datas];
////    tempData = [outFile readDataToEndOfFile];
////    [inFile writeData:[Transcoder transcodeData:tempData]];
////    FILE *fp;
////    fp = fopen([filePath cStringUsingEncoding:NSASCIIStringEncoding], "rb");
//    [inFile closeFile];
//    [outFile closeFile];
//    lame_close(lame);
//    
//}




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
        
    }
    
}


//+ (NSData *)transcodeData:(NSData *)data{
//    
//    lame_t lame;
//    // mp3压缩参数
//    lame = lame_init();
//    lame_set_num_channels(lame, 1);
//    lame_set_in_samplerate(lame, 44100);
//    lame_set_brate(lame, 16);
//    lame_set_mode(lame, 1);
//    lame_set_quality(lame, 2);
//    lame_init_params(lame);
//    
//    NSMutableData *mp3Datas = [[NSMutableData alloc] init];
//    
//    
//    
//    short *recordingData = (short *)data.bytes;
//    int pcmLen = (int)data.length;
//    int nsamples = pcmLen / 2;
//    
//    unsigned char buffer[pcmLen];
//    // mp3 encode
//    int recvLen = lame_encode_buffer(lame, recordingData, recordingData, nsamples, buffer, pcmLen);
//    // add NSMutable
//    [mp3Datas appendBytes:buffer length:recvLen];
//    
//    lame_close(lame);
//    return mp3Datas;
//}
@end
