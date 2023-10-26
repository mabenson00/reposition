# Reposition Gem: README.md

## Overview

The `Reposition` gem provides functionality to manage the reordering of objects in a list. It's original intended use is for drag and drop using `react-dnd`

## How It Works

`Reposition` uses relative objects to set the position.
- `preceding_object` is the object before the __new__ position
- `following_object` is the object after the __new__ position
- `object` is the object itself.

Using this data, the `Reposition` gem adjusts the position of the dragged object:

- If there is no preceding object (i.e., the object was moved to the beginning), it's positioned just before the following object.
- If there's no following object (i.e., the object was moved to the end), it's positioned just after the preceding object.
- If both a preceding and following object exist, the dragged object's position is set to the midpoint between these two objects.

The position attribute is a floating point, allowing for a vast range of intermediary values. Over time, with enough reordering operations, there's a potential to reach the precision limit of the floating point. However, the available precision ensures this would take a substantial number of operations to become a concern.


## A Note on Position Numbers

When using the `Reposition` gem, you might observe certain characteristics about the position values. It's essential to be aware of these nuances:

- **High Precision Numbers:** As you reorder items, you may notice position values with extended decimal places. This is due to the gem's strategy of determining midpoints between existing positions.

- **Negative Numbers:** Especially if items are repeatedly moved to the beginning of the list, it's possible for position values to turn negative.

Both of these behaviors are by design. The gem aims to facilitate a vast range of reordering actions without the constant need to adjust the positions of all items in the list. While these position numbers might look unconventional, they serve a purpose, ensuring efficient reordering over extended usage. If you ever find the need to "normalize" these values, you could consider a one-time adjustment of all positions within a more conventional range.

## Usage

To utilize the `Reposition` gem, you would generally follow these steps:

1. Ensure the model or object you're reordering has a floating-point attribute, which will store the position. For example: `position`.

2. When reordering is needed, call the `reposition` method:

```ruby
Reposition.reposition(
  object: object_to_reposition,
  preceding_object: object_before,
  following_object: object_after,
  attribute_name: :position,
  options: { validate: true, save: "save!" }
)
```

### Parameters:

- `object`: The main object you want to reposition.
- `preceding_object`: The object that comes before your main object after reordering.
- `following_object`: The object that comes after your main object after reordering.
- `attribute_name`: The attribute you're using to store the position (e.g., `:position`).
- `options`: A hash with additional options. For now, it includes:
  - `:validate`: A boolean indicating if the object should be validated before saving. Defaults to true.
  - `:save`: options: 'save', 'save!' 'save!' can also be accomplished by calling `Reposition.reposition!(...)`

## Installation

(Installation instructions would go here, detailing how to add the gem to a Gemfile, and any post-installation setup required.)

## Contributing

We welcome contributions! If you find a bug or would like to add a new feature, please create an issue or submit a pull request on our GitHub repository.

## License

This gem is available as open-source under the terms of the (specific license, e.g., MIT License).
