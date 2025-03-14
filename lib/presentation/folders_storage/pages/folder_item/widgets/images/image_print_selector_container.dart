import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_app/entities/order/bloc/order_bloc.dart';
import 'package:photo_app/entities/sizes/bloc/sizes_bloc.dart';
import 'package:photo_app/entities/sizes/bloc/sizes_state.dart';
import 'package:photo_app/presentation/folders_storage/pages/folder_item/widgets/images/image_print_selector.dart';

class ImagePrintSelectorContainer extends StatelessWidget {
  final int imageId;
  final int folderId;
  const ImagePrintSelectorContainer({
    super.key,
    required this.imageId,
    required this.folderId,
  });

  @override
  Widget build(BuildContext context) {
    final sizesBloc = context.read<SizesBloc>();
    final orderBloc = context.read<OrderBloc>();

    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: sizesBloc),
        BlocProvider.value(value: orderBloc),
      ],
      child: BlocBuilder<SizesBloc, SizesState>(
        builder: (context, state) {
          if (state is SizesLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is SizesLoaded) {
            return SizedBox(
              height: 200,
              child: ListView.builder(
                itemCount: state.sizes.length,
                itemBuilder: (context, index) {
                  return ImagePrintSelector(
                    size: state.sizes[index],
                    imageId: imageId,
                    folderId: folderId,
                  );
                },
              ),
            );
          }
          return const Center(child: Text('Error'));
        },
      ),
    );
  }
}
