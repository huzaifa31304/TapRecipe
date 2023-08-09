class Model
{
  String? image, url, source, label;
  bool isFavorite;
  Model({
    this.image,
    this.url,
    this.source,
    this.label,
    this.isFavorite=false,
  });
}