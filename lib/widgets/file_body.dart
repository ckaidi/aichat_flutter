import 'package:chat_flutter/utils/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FileBody extends StatelessWidget {
  final String filename;
  final String? fileExtension;
  final int fileSize;
  final VoidCallback? onRemove;

  const FileBody({
    super.key,
    required this.filename,
    this.fileExtension,
    required this.fileSize,
    this.onRemove,
  });

  String nameShow() {
    if (filename.length < 20) {
      return filename;
    }
    return "${filename.substring(0, 17)}...";
  }

  bool isImage() {
    if (fileExtension == null) {
      return false;
    }
    if (Config.imageExtensions.contains(fileExtension!.toUpperCase())) {
      return true;
    }
    return false;
  }

  Widget _buildFileShow() {
    return Row(
      mainAxisAlignment:
          onRemove == null ? MainAxisAlignment.end : MainAxisAlignment.start,
      crossAxisAlignment:
          onRemove == null ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      mainAxisSize:
          onRemove == null
              ? MainAxisSize.min
              : MainAxisSize.max, // 最小宽度，避免撑满父容器的宽度,
      children: [
        isImage()
            ? SvgPicture.string(
              '<svg width="32" height="32" viewBox="0 0 32 32" fill="none" xmlns="http://www.w3.org/2000/svg"><path d="M21.4237 7H10.5763C8.04887 7 6 8.94521 6 11.3447V20.6544C6 23.054 8.04887 24.9992 10.5763 24.9992H21.4237C23.9511 24.9992 26 23.054 26 20.6544V11.3447C26 8.94521 23.9511 7 21.4237 7Z" fill="#9AD2EC"></path><path d="M11.3448 14.2014C12.3922 14.2014 13.2413 13.3955 13.2413 12.4015C13.2413 11.4074 12.3922 10.6016 11.3448 10.6016C10.2974 10.6016 9.44824 11.4074 9.44824 12.4015C9.44824 13.3955 10.2974 14.2014 11.3448 14.2014Z" fill="white"></path><path d="M25.9989 15.4688L21.3278 19.2012C20.7752 19.6428 20.0993 19.9222 19.3825 20.0054C18.6656 20.0886 17.9387 19.972 17.2904 19.6699L13.5988 17.9489C13.0423 17.6896 12.4264 17.5663 11.8069 17.5902C11.1875 17.6141 10.5841 17.7845 10.0516 18.0859L6.00098 20.3788V20.6554C6.00089 21.226 6.11915 21.7909 6.34906 22.318C6.57896 22.8452 6.91598 23.3241 7.34087 23.7276C7.76576 24.131 8.27022 24.4511 8.82541 24.6694C9.38059 24.8878 9.97563 25.0002 10.5766 25.0002H21.4247C22.6381 24.9998 23.8017 24.5419 24.6595 23.7271C25.5173 22.9123 25.9991 21.8074 25.9989 20.6554V15.4688Z" fill="#4579C7"></path></svg>',
              width: 32,
              height: 32,
            )
            : SvgPicture.string(
              '<svg width="32" height="32" viewBox="0 0 32 32" fill="none" xmlns="http://www.w3.org/2000/svg"><path d="M7 9C7 6.79086 8.79086 5 11 5L18.6383 5C19.1906 5 19.6383 5.44772 19.6383 6V6.92308C19.6383 9.13222 21.4292 10.9231 23.6383 10.9231H24C24.5523 10.9231 25 11.3708 25 11.9231V23C25 25.2091 23.2091 27 21 27H11C8.79086 27 7 25.2091 7 23V9Z" fill="#F8CA27"></path><g filter="url(#filter0_d_602_422)"><path d="M19.6602 6.92458V5.84766L24.4126 10.9246H23.6602C21.451 10.9246 19.6602 9.13372 19.6602 6.92458Z" fill="#F8EDC7"></path></g><path d="M20.2557 12H11.7443C11.3332 12 11 12.3358 11 12.75C11 13.1642 11.3332 13.5 11.7443 13.5H20.2557C20.6668 13.5 21 13.1642 21 12.75C21 12.3358 20.6668 12 20.2557 12Z" fill="#F8EDC7"></path><path d="M20.2557 16L11.7443 16.0017C11.3332 16.0017 11 16.3371 11 16.7509C11 17.1646 11.3332 17.5 11.7443 17.5L20.2557 17.4983C20.6668 17.4983 21 17.1629 21 16.7491C21 16.3354 20.6668 16 20.2557 16Z" fill="#F8EDC7"></path><path d="M15.3575 20H11.6425C11.2876 20 11 20.3358 11 20.75C11 21.1642 11.2876 21.5 11.6425 21.5H15.3575C15.7124 21.5 16 21.1642 16 20.75C16 20.3358 15.7124 20 15.3575 20Z" fill="#F8EDC7"></path><defs><filter id="filter0_d_602_422" x="19.1602" y="5.34766" width="7.75195" height="8.07617" filterUnits="userSpaceOnUse" color-interpolation-filters="sRGB"><feFlood flood-opacity="0" result="BackgroundImageFix"></feFlood><feColorMatrix in="SourceAlpha" type="matrix" values="0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 127 0" result="hardAlpha"></feColorMatrix><feOffset dx="1" dy="1"></feOffset><feGaussianBlur stdDeviation="0.75"></feGaussianBlur><feComposite in2="hardAlpha" operator="out"></feComposite><feColorMatrix type="matrix" values="0 0 0 0 0.591623 0 0 0 0 0.452482 0 0 0 0 0.0698445 0 0 0 0.25 0"></feColorMatrix><feBlend mode="normal" in2="BackgroundImageFix" result="effect1_dropShadow_602_422"></feBlend><feBlend mode="normal" in="SourceGraphic" in2="effect1_dropShadow_602_422" result="shape"></feBlend></filter></defs></svg>',
              width: 32,
              height: 32,
            ),
        const SizedBox(width: 8),
        onRemove == null
            ? _buildInternalFileShow()
            : Expanded(child: _buildInternalFileShow()),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildInternalFileShow() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          nameShow(),
          style: const TextStyle(fontWeight: FontWeight.bold),
          overflow: TextOverflow.ellipsis,
        ),
        Row(
          children: [
            if (fileExtension != null)
              Text(
                fileExtension!.toUpperCase(),
                style: TextStyle(fontSize: 12, color: Colors.grey.shade400),
              ),
            if (fileExtension != null) const SizedBox(width: 4),
            Text(
              '${(fileSize / 1024).toStringAsFixed(2)}KB',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade400),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildContainer() {
    return Container(
      alignment: AlignmentDirectional.centerEnd,
      child: Container(
        padding: EdgeInsets.only(top: 5, bottom: 5, left: 5, right: 5),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(16),
        ),
        height: 49,
        child: _buildFileShow(),
      ),
    );
  }

  Widget _buildCloseButton() {
    return Positioned(
      top: 0,
      right: 0,
      child: InkWell(
        onTap: () {
          onRemove?.call();
        },
        child: Container(
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.grey.shade300, width: .5),
          ),
          child: SvgPicture.string(
            '<svg width="8" height="8" viewBox="0 0 8 8" fill="none" xmlns="http://www.w3.org/2000/svg"><path fill-rule="evenodd" clip-rule="evenodd" d="M7.45.549a.777.777 0 0 1 0 1.098L1.648 7.451A.776.776 0 1 1 .55 6.353L6.353.55a.776.776 0 0 1 1.098 0z" fill="#868686"></path><path fill-rule="evenodd" clip-rule="evenodd" d="M.55.548a.776.776 0 0 1 1.097 0l5.804 5.805A.777.777 0 0 1 6.353 7.45L.549 1.646a.777.777 0 0 1 0-1.098z" fill="#868686"></path></svg>',
            width: 8,
            height: 8,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final c = [_buildContainer(), if (onRemove != null) _buildCloseButton()];
    return Padding(
            padding: const EdgeInsets.only(
              left: 6,
              right: 6,
              bottom: 6,
              top: 0,
            ),
      child: onRemove == null ? _buildContainer() : Stack(children: c),
    );
  }
}
