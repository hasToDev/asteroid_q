import 'package:asteroid_q/core/core.dart';
import 'package:flutter/services.dart';

class KeyboardInput {
  KeyboardInput._();

  /// Get Keyboard Action and/or Next Focus Index
  static (KeyboardAction action, int nextFocusIndex) gameBoard(
    KeyEvent event,
    int focusedIndex,
    int boxNumber,
  ) {
    int newIndex = focusedIndex;
    KeyboardAction newAction = KeyboardAction.none;

    if (event is KeyDownEvent) {
      switch (event.logicalKey) {
        case LogicalKeyboardKey.keyW:
        case LogicalKeyboardKey.arrowUp:
          // Handle up movement
          newAction = KeyboardAction.select;
          newIndex = _moveUP(newIndex, boxNumber, focusedIndex);
          break;
        case LogicalKeyboardKey.keyS:
        case LogicalKeyboardKey.arrowDown:
          // Handle down movement
          newAction = KeyboardAction.select;
          newIndex = _moveDOWN(newIndex, boxNumber, boxNumber, focusedIndex);
          break;
        case LogicalKeyboardKey.keyA:
        case LogicalKeyboardKey.arrowLeft:
          // Handle left movement
          newAction = KeyboardAction.select;
          newIndex = _moveLEFT(newIndex, boxNumber);
          break;
        case LogicalKeyboardKey.keyD:
        case LogicalKeyboardKey.arrowRight:
          // Handle right movement
          newAction = KeyboardAction.select;
          newIndex = _moveRIGHT(newIndex, boxNumber, focusedIndex);
          break;
        case LogicalKeyboardKey.keyU:
          // Handle U key -- UPGRADE ship
          // TODO: implement upgrade in the future
          newAction = KeyboardAction.upgrade;
          break;
        case LogicalKeyboardKey.keyR:
          // Handle R key -- HARVEST or REFUEL ship
          newAction = KeyboardAction.refuel;
          break;
        case LogicalKeyboardKey.space:
          // Handle space -- SHOOT asteroid
          newAction = KeyboardAction.shoot;
          break;
        case LogicalKeyboardKey.enter:
          // Handle enter -- MOVE ship
          newAction = KeyboardAction.move;
          break;
      }
    } else if (event is KeyRepeatEvent) {
      switch (event.logicalKey) {
        case LogicalKeyboardKey.keyW:
        case LogicalKeyboardKey.arrowUp:
          // Handle up movement
          newAction = KeyboardAction.select;
          newIndex = _moveUP(newIndex, boxNumber, focusedIndex);
          break;
        case LogicalKeyboardKey.keyS:
        case LogicalKeyboardKey.arrowDown:
          // Handle down movement
          newAction = KeyboardAction.select;
          newIndex = _moveDOWN(newIndex, boxNumber, boxNumber, focusedIndex);
          break;
        case LogicalKeyboardKey.keyA:
        case LogicalKeyboardKey.arrowLeft:
          // Handle left movement
          newAction = KeyboardAction.select;
          newIndex = _moveLEFT(newIndex, boxNumber);
          break;
        case LogicalKeyboardKey.keyD:
        case LogicalKeyboardKey.arrowRight:
          // Handle right movement
          newAction = KeyboardAction.select;
          newIndex = _moveRIGHT(newIndex, boxNumber, focusedIndex);
          break;
        default:
          break;
      }
    }

    return (newAction, newIndex);
  }

  /// Get Keyboard Action and/or Next Focus Index from Virtual Action
  static (KeyboardAction action, int nextFocusIndex) forVirtualAction(
    VirtualAction event,
    int focusedIndex,
    int boxNumber,
  ) {
    int newIndex = focusedIndex;
    KeyboardAction newAction = KeyboardAction.none;

    switch (event) {
      case VirtualAction.up:
        // Handle up movement
        newAction = KeyboardAction.select;
        newIndex = _moveUP(newIndex, boxNumber, focusedIndex);
        break;
      case VirtualAction.down:
        // Handle down movement
        newAction = KeyboardAction.select;
        newIndex = _moveDOWN(newIndex, boxNumber, boxNumber, focusedIndex);
        break;
      case VirtualAction.left:
        // Handle left movement
        newAction = KeyboardAction.select;
        newIndex = _moveLEFT(newIndex, boxNumber);
        break;
      case VirtualAction.right:
        // Handle right movement
        newAction = KeyboardAction.select;
        newIndex = _moveRIGHT(newIndex, boxNumber, focusedIndex);
        break;
      case VirtualAction.refuel:
        // Handle R key -- HARVEST or REFUEL ship
        newAction = KeyboardAction.refuel;
        break;
      case VirtualAction.shoot:
        // Handle space -- SHOOT asteroid
        newAction = KeyboardAction.shoot;
        break;
      case VirtualAction.move:
        // Handle enter -- MOVE ship
        newAction = KeyboardAction.move;
        break;
    }

    return (newAction, newIndex);
  }

  static int _moveLEFT(int index, int columns) {
    if (index == NextGalaxy.right.id) return SpaceTilePosition.right.id;
    if (index == NextGalaxy.left.id) return index;
    if (index == NextGalaxy.top.id || index == NextGalaxy.bottom.id) return NextGalaxy.left.id;
    if (index % columns > 0) return index - 1;
    return NextGalaxy.left.id;
  }

  static int _moveRIGHT(int index, int columns, int focusedIndex) {
    if (index == NextGalaxy.left.id) return SpaceTilePosition.left.id;
    if (index == NextGalaxy.right.id) return index;
    if (index == NextGalaxy.top.id || index == NextGalaxy.bottom.id) return NextGalaxy.right.id;
    if (focusedIndex % columns < columns - 1) return index + 1;
    return NextGalaxy.right.id;
  }

  static int _moveUP(int index, int columns, int focusedIndex) {
    if (index == NextGalaxy.bottom.id) return SpaceTilePosition.bottom.id;
    if (index == NextGalaxy.top.id) return index;
    if (index == NextGalaxy.right.id || index == NextGalaxy.left.id) return NextGalaxy.top.id;
    if (focusedIndex >= columns) return index - columns;
    return NextGalaxy.top.id;
  }

  static int _moveDOWN(int index, int columns, int rows, int focusedIndex) {
    if (index == NextGalaxy.top.id) return SpaceTilePosition.top.id;
    if (index == NextGalaxy.bottom.id) return index;
    if (index == NextGalaxy.right.id || index == NextGalaxy.left.id) return NextGalaxy.bottom.id;
    if (focusedIndex < (rows - 1) * columns) return index + columns;
    return NextGalaxy.bottom.id;
  }
}
