import { registerPlugin } from '@capacitor/core';
export interface IMAPlugin {
  playAd(options: { adTagUrl: string }): Promise<{result: boolean}>;
}
const IMA = registerPlugin<IMAPlugin>('IMA');
export default IMA;
